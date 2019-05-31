package main

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	"github.com/sirupsen/logrus"
)

// API is the service API.
type API struct {
}

func (a *API) home(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Hello world!"))
}

func main() {
	addr := ":8080"
	r := httprouter.New()
	svc := &API{}

	r.GET("/", svc.home)

	logrus.Infof("Listening on %s", addr)
	if err := http.ListenAndServe(addr, r); err != nil {
		logrus.Fatal(err)
	}
}
