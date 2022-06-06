#!/bin/bash

# Get Port from the service.
INVOICES_PORT=$(kubectl get svc -l app=invoices-app -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}')

echo "> Check invoices. It's expected that they all are unpaid"
EXPECTED=3
UNPAID=$(curl -X GET -s http://127.0.0.1:30697/invoices | jq '.[] | select(.IsPaid == false) | .IsPaid' | wc -l | xargs)
if [ ${EXPECTED} -eq ${UNPAID} ]; then
    echo ">> SUCCESS"
else
    echo ">> ERROR"
    echo ">> Expected ${EXPECTED}, found ${UNPAID}."
fi

# Pay invoices
RESULT=$(curl -X POST -s http://127.0.0.1:30697/invoices/pay)

sleep 2

echo "> Check invoices. It's expected that they all are paid"
EXPECTED=3
UNPAID=$(curl -X GET -s http://127.0.0.1:30697/invoices | jq '.[] | select(.IsPaid == true) | .IsPaid' | wc -l | xargs)
if [ ${EXPECTED} -eq ${UNPAID} ]; then
    echo ">> SUCCESS"
else
    echo ">> ERROR"
    echo ">> Expected ${EXPECTED}, found ${UNPAID}."
fi