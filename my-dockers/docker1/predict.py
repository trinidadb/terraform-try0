import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def predict():
    logger.info(f"Predict called")

def handler(event,context):
    logger.info("Event: %s", event)
    predict(numDays=5)
