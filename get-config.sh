set -eu pipefail

#create kustomer config file
KUSTOMER_TOKEN=`echo $KUSTOMER_API_KEY | sed 's/[{}]//g' | sed 's/\"\"/\"/g'`
START_DATE="\"2020-12-01T00:00:00Z\""
echo "{$KUSTOMER_TOKEN,\"start_date\": $START_DATE,\"user_agent\": \"tap-kustomer hanna.murphy@beam.dental\",\"date_window_size\": \"60\", \"page_size_limit\": \"100\"}" > /home/tap-kustomer/kustomer-config.json

#create kustomer state file
CONVERSATIONS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"conversations"}}' --region us-east-1 --query 'Item.lastExec.S'`
CUSTOMERS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"customers"}}' --region us-east-1 --query 'Item.lastExec.S'`
KOBJECTS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"kobjects"}}' --region us-east-1 --query 'Item.lastExec.S'`
MESSAGES=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"messages"}}' --region us-east-1 --query 'Item.lastExec.S'`
SHORTCUTS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"shortcuts"}}' --region us-east-1 --query 'Item.lastExec.S'`
TAGS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"tags"}}' --region us-east-1 --query 'Item.lastExec.S'`
USERS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"users"}}' --region us-east-1 --query 'Item.lastExec.S'`
NOTES=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"notes"}}' --region us-east-1 --query 'Item.lastExec.S'`
TEAMS=`aws dynamodb get-item --table-name kustomer_state_prod --key '{"bookmark": {"S":"teams"}}' --region us-east-1 --query 'Item.lastExec.S'`

echo "{\"bookmarks\": {\"conversations\": $CONVERSATIONS, \"customers\": $CUSTOMERS, \"kobjects\": $KOBJECTS, \"messages\": $MESSAGES, \"shortcuts\": $SHORTCUTS, \"tags\": $TAGS, \"users\": $USERS, \"teams\": $TEAMS}}" > /home/tap-kustomer/kustomer-state.json


#create stitch config file
TOKEN=`echo $STITCH_TOKEN | sed 's/[{}]//g' | sed 's/\"\"/\"/g'`
echo "{\"client_id\": $STITCH_CLIENT_ID, $TOKEN, \"small_batch_url\": \"https://api.stitchdata.com/v2/import/batch\",\"big_batch_url\": \"https://api.stitchdata.com/v2/import/batch\",\"batch_size_preferences\": {}}" > /home/tap-kustomer/stitch-config.json


echo "Files created in /home/tap-kustomer/" >&2
ls -la /home/tap-kustomer >&2