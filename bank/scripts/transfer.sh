#! /bin/bash
from_id=$(curl -s -X POST 'http://localhost:4000/api/accounts/create?initial_balance=42' | jq -r '.data.uuid')
to_id=$(curl -s -X POST 'http://localhost:4000/api/accounts/create?initial_balance=73' | jq -r '.data.uuid')
echo "get(from): $(curl -s -X GET http://localhost:4000/api/accounts/${from_id})"
echo "get(to): $(curl -s -X GET http://localhost:4000/api/accounts/${to_id})"
echo "transfer: $(curl -s -X PUT http://localhost:4000/api/accounts/${from_id}/transfer?to_id=${to_id}\&amount=42)"
echo "get(from): $(curl -s -X GET http://localhost:4000/api/accounts/${from_id})"
echo "get(to): $(curl -s -X GET http://localhost:4000/api/accounts/${to_id})"
echo "withdraw(to): $(curl -s -X PUT http://localhost:4000/api/accounts/${to_id}/withdraw?amount=115)"
echo "delete(from): $(curl -s -X PUT http://localhost:4000/api/accounts/${from_id}/delete)"
echo "delete(to): $(curl -s -X PUT http://localhost:4000/api/accounts/${to_id}/delete)"
