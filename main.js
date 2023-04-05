const Jimp = require("jimp");
const express = require("express");
const bodyparser = require("body-parser");

// We can now decide the resolution that we want ::
let XRES = 50;
let YRES = 50;

var ColorInfo = [];

/*
    To convert the above Python program to Node.js, you can use the Jimp library to manipulate images. Here's an example of how you can create a new image, 
    set a single pixel to a specific color, and then save the image:

        const Jimp = require('jimp');

        const width = 1000;
        const height = 1000;
        const color = { r: 100, g: 12, b: 13 };

        const img = new Jimp(width, height, (err, image) => {
            if (err) throw err;
            image.setPixelColor(Jimp.rgbaToInt(color.r, color.g, color.b, 255), 10, 10);
            image.write('test3.png');
        });

    Here, we're using the Jimp constructor to create a new image with the specified dimensions. We're also setting a color object with the RGB values we want to use for our pixel.

    Inside the constructor's callback function, we're checking for any errors that might occur during the image creation process. Then, we're using the setPixelColor 
    method to set the color of the pixel at (10, 10) to the color we defined earlier.

    Finally, we're using the write method to save the image to a file named "test3.png".
*/

function RenderPixel(){
    console.log("Rendering begins...");
    
    const img = new Jimp(XRES, YRES, (err, image) => {
        if (err) throw err;

        /* ColorInfo contains all the rows, each row has many pixels. Each pixel contains Color and Inshade info */

        for (var x in ColorInfo){
            for (var z in ColorInfo[x]) {
                var colorinfo = ColorInfo[x][z];
                //console.log(`(${x}, ${z}) -> `, colorinfo);
                image.setPixelColor(Jimp.rgbaToInt(colorinfo.Color[0], colorinfo.Color[1], colorinfo.Color[2], 255), Number(x), Number(z));
            }
        }
        image.write('test.png');
    });

    console.log("Rendering Complete!");
}

var app = express();

app.use(bodyparser.json({ limit: "100mb" }))
app.use(bodyparser.urlencoded({ limit: "100mb", extended: true, parameterLimit: 100000 }))


app.post("/", function(req, res){
    const body = req.body;
    const ColorInformation = body.ColorInformation;

    /*
        We expect a 2D Array which contains all the pixel data
        Each pixel data is an array which contains the following information ::
        {
            "Color": {r: float, g: float, b: float},
            "InShade": bool
        }
    */

    XRES = ColorInformation.length;
    YRES = ColorInformation[0].length;

    console.log("Width:", XRES);
    console.log("Length:", YRES);

    ColorInfo = ColorInformation;

    res.send();

    /* We're done with the requests, let's start rendering the image */
    RenderPixel();
})

app.listen(3000, (err) => {
    if (err) throw err;

    console.log("Server started on port 3000");
})