import express from "express";
import * as path from "path";
import * as bodyParser from "body-parser";
import { mainRoutes } from "./routes/MainRoutes";

// inspired by https://blog.morizyun.com/blog/typescript-express-tutorial-javascript-nodejs/index.html
class App {
    public app: express.Application;

    constructor() {
        this.app = express();
        this.config();
    }

    private config(): void {


        // https://www.tonyerwin.com/2014/09/redirecting-http-to-https-with-nodejs.html
        this.app.use(function (req, res, next) {
            if (req.secure) {
                // request was via https, so do no special handling
                next();
            } else {
                // request was via http, so redirect to https
                res.redirect('https://' + req.headers.host + req.url);
            }
        });

        // support application/json
        this.app.use(bodyParser.json());
        //support application/x-www-form-urlencoded post data
        this.app.use(bodyParser.urlencoded({ extended: false }));

        this.app.use( express.static(path.join(__dirname, 'public')) );
        this.app.use("/", mainRoutes); // will only catch the stuff that is not found in "public"
    }
}

export default new App().app;
