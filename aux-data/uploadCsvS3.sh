
BUCKET_NAME="my-bucket"

aws s3 cp my-csv.csv "s3://$BUCKET_NAME/aux-data/"
