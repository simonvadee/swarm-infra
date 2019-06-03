package main

import (
	"io/ioutil"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"github.com/sirupsen/logrus"
)

// API is the service API.
type API struct {
}

func (a *API) home(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	resp, err := http.Get("http://whoami/")
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(b)
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
