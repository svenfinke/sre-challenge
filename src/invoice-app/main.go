package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"pleo.io/invoice-app/db"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	dbClient = db.InitializeDatabase()

	router := setupRouter()

	err := router.Run(":8081")
	if err != nil {
		fmt.Printf("could not start server: %v", err)
	}
}

func setupRouter() *gin.Engine {
	r := gin.New()
	r.POST("invoices/pay", pay)
	r.GET("invoices", getInvoices)
	return r
}

func getInvoices(c *gin.Context) {
	invoices := dbClient.GetInvoices()

	c.JSON(http.StatusOK, invoices)
}

func pay(c *gin.Context) {
	paymentProviderURL := os.Getenv("payment-provider-url")
	invoices := dbClient.GetUnpaidInvoices()
	for _, invoice := range invoices {
		client := http.Client{}
		req := payRequest{
			Id:       invoice.InvoiceId,
			Value:    invoice.Value,
			Currency: invoice.Currency,
		}
		b, err := json.Marshal(req)
		data := bytes.NewBuffer(b)
		_, err = client.Post(paymentProviderURL + "/payments/pay", "application/json", data)

		if err != nil {
			fmt.Printf("Error %s", err)
			c.JSON(http.StatusInternalServerError, gin.H{ "Error": err })
			return
		}

		dbClient.PayInvoice(invoice.InvoiceId)
	}

	fmt.Printf("Invoices paid!\n")

	c.JSON(http.StatusOK, gin.H{})
}

var dbClient *db.Client

type payRequest struct {
	Id       string  `json:"id"`
	Value    float32 `json:"value"`
	Currency string  `json:"currency"`
}
