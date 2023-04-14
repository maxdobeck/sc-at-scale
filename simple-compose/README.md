# simple-compose
Opens two Sauce Connect proxies in two regions, us-west-1 & eu-central-1. Same account and user but this makes it possible for both Sauce Labs regions to reach the example application under test (mockserver container).

The primary takeaway is that the conatiner_name value is essentially being used to resolve the application's IP address. i.e. you don't have to rely on localhost or changing the /etc/hosts file of your machine(s).