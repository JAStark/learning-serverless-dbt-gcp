import logging
import os

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

# slack_token = os.environ['SLACK_BOT_TOKEN']
slack_token = "abc-123"
client = WebClient(token=slack_token)
res = client.api_test()

# try:
#     response = client.chat_postMessage(
#         channel="",
#         text="Hello test error occured in xxx"
#     )
#     print("all done")
# except SlackApiError as e:
#     # you will get a SlackApiError if "ok" is False
#     print("fail")
#     assert e.response["error"]
