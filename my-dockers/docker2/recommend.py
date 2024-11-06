
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def recommend():
    logger.info(f"Recommender called")

def handler(event, context):
    logger.info("Event: %s", event)
    recommend()
