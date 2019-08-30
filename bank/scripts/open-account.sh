#! /bin/bash
curl -X POST -H 'Content-Type: application/json' -d '{"account": {"initial_balance": 1000}}' http://localhost:4000/api/accounts
