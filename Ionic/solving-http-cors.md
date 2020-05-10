# Solving the HTTP CORS Issue with Ionic Applications

When developing with Ionic you will run into an issue when making CORS requests, there are many ways to mitigate this such as creating a proxy server application and also use the built-in ionic proxy. The latter of which (so far as I know) will not work in production. In order to solve this we can make use of the Cordova Native HTTP library among other solutions

## Possible Solutions 
Some possible resources that outline some potential solutions

- [Dealing with Cors for Ionic Applications](https://www.joshmorony.com/dealing-with-cors-cross-origin-resource-sharing-in-ionic-applications/)
- [Solution to Ionic 3 CORS with Cordova](https://hackernoon.com/a-practical-solution-for-cors-cross-origin-resource-sharing-issues-in-ionic-3-and-cordova-2112fc282664)
- [Ionic Native](https://ionicframework.com/docs/native/http/)