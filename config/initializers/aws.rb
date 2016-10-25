AWS.config(
   :access_key_id => ENV['S3_KEY'],
   :secret_access_key => ENV['S3_SECRET'],
)

s3 = AWS::S3.new
S3_BUCKET = s3.buckets[ENV['AS3_BUCKET']]
