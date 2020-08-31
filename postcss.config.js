const postcssNesting = require('postcss-nesting');

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
const rucksack = require('rucksack-css');
const postcssExtendRule = require('postcss-extend-rule');
const calc = require("postcss-calc")



module.exports = {
  plugins: [

    postcssImport,
    require('postcss-nested'),
    calc,
    assets({
        loadPaths: ['images/']
    }),
    postcssPresetEnv({
        stage:3,
        autoprefixer: { grid: true , flex:false},
           browsers: ['last 2 versions', '> 5%', 'ie 8'],
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

   postcssNesting,
   postcssExtendRule,
   rucksack,
   mqpacker,
//    require('cssnano')({
//     preset: 'default',
// }),
  ]
}