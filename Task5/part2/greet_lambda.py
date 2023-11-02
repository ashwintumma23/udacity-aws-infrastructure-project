import os

def lambda_handler(event, context):
    print("{} from Lambda!".format(os.environ['greeting']))
    return "{} from Lambda!".format(os.environ['greeting'])
