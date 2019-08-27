#! /bin/bash
curl -X POST -H 'application/json' '{"account": {"initial_balance": 1000}}' http://localhost:4000/api/accounts
