#! /bin/bash
account_id=$(curl -s -X POST 'http://localhost:4000/api/accounts/create?initial_balance=42' | jq -r '.data.uuid')
echo "get: $(curl -s -X GET http://localhost:4000/api/accounts/${account_id})"
echo "deposit: $(curl -s -X PUT http://localhost:4000/api/accounts/${account_id}/deposit?amount=73)"
echo "withdraw: $(curl -s -X PUT http://localhost:4000/api/accounts/${account_id}/withdraw?amount=115)"
echo "delete: $(curl -s -X PUT http://localhost:4000/api/accounts/${account_id}/delete)"
