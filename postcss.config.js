const postcssPresetEnv = require('postcss-preset-env');
const postcssImport = require('postcss-import')({
    plugins:[
        require("stylelint"),
    ]
    
});
const fontMagician = require('postcss-font-magician');
const assets  = require('postcss-assets');
const stylelint = require("stylelint");
const mqpacker = require("css-mqpacker");


module.exports = {
  plugins: [
    postcssImport,
    assets({
        loadPaths: ['images/']
    }),
    postcssPresetEnv({
        stage:3,
        autoprefixer: { grid: true },
           browsers: 'last 2 versions',
           preserve: false,
    }),
    fontMagician({
        variants: {
            'Latto': {
                '300': [],
                '400': [],
                '700': []
            }
        },
        foundries: ['google']
   }),
   mqpacker,
   require('cssnano')({
    preset: 'default',
}),
  ]
}