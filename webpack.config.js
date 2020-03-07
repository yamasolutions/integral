const path = require("path")
const CopyPlugin = require('copy-webpack-plugin');



module.exports = {
  entry: {
    "activestorage": path.resolve(__dirname, "app/javascript/packs/backend.js"),
  },
  output: {
    filename: "backend-pack.js",
    path: path.resolve(__dirname, "app/assets/javascripts/integral"),
    library: "Integral",
    libraryTarget: "umd"
  },
  plugins: [
    new CopyPlugin([
      { from: 'node_modules/ckeditor4/', to: path.resolve(__dirname, "public/packs/ckeditor") }
    ])
  ],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  }
}
