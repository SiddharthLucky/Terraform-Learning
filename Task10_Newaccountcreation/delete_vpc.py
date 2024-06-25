import boto3
import sys
import json


def main():
    query = json.loads(sys.stdin.read())
    new_account_id = query["new_account_id"]

    role_arn = f"arn:aws:iam::{new_account_id}:role/DefaultVpcDelete"
    session_name = "DeleteDefaultVpcSession"

    # Assume the role
    sts_client = boto3.client("sts")
    assumed_role = sts_client.assume_role(
        RoleArn=role_arn, RoleSessionName=session_name
    )

    # Create a session with the assumed role credentials
    session = boto3.Session(
        aws_access_key_id=assumed_role["Credentials"]["AccessKeyId"],
        aws_secret_access_key=assumed_role["Credentials"]["SecretAccessKey"],
        aws_session_token=assumed_role["Credentials"]["SessionToken"],
    )

    regions = get_all_regions(session)
    results = []

    for region in regions:
        result = delete_default_vpc(session, region)
        results.append(result)

    # Flatten results into a single string
    result_str = "; ".join([f"{res['region']}: {res['status']}" for res in results])
    print(json.dumps({"vpc_deletion_status": result_str}))


def get_all_regions(session):
    ec2 = session.client("ec2")
    regions = ec2.describe_regions()
    return [region["RegionName"] for region in regions["Regions"]]


def delete_default_vpc(session, region):
    ec2 = session.client("ec2", region_name=region)
    vpcs = ec2.describe_vpcs(Filters=[{"Name": "isDefault", "Values": ["true"]}])
    if not vpcs["Vpcs"]:
        return {"region": region, "status": "No default VPC found"}

    default_vpc_id = vpcs["Vpcs"][0]["VpcId"]

    # Delete subnets
    subnets = ec2.describe_subnets(
        Filters=[{"Name": "vpc-id", "Values": [default_vpc_id]}]
    )
    for subnet in subnets["Subnets"]:
        ec2.delete_subnet(SubnetId=subnet["SubnetId"])

    # Detach and delete internet gateways
    igws = ec2.describe_internet_gateways(
        Filters=[{"Name": "attachment.vpc-id", "Values": [default_vpc_id]}]
    )
    for igw in igws["InternetGateways"]:
        ec2.detach_internet_gateway(
            InternetGatewayId=igw["InternetGatewayId"], VpcId=default_vpc_id
        )
        ec2.delete_internet_gateway(InternetGatewayId=igw["InternetGatewayId"])

    # Finally, delete the default VPC
    ec2.delete_vpc(VpcId=default_vpc_id)
    return {"region": region, "status": f"Deleted default VPC {default_vpc_id}"}


if __name__ == "__main__":
    main()
