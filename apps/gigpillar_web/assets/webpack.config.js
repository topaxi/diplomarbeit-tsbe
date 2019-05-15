const path = require('path')
const glob = require('glob')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ImageminPlugin = require('imagemin-webpack-plugin').default
const imageminMozjpeg = require('imagemin-mozjpeg')
// const ZopfliPlugin = require('zopfli-webpack-plugin')
const BrotliPlugin = require('brotli-webpack-plugin')

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new TerserPlugin({
        cache: true,
        parallel: true,
        sourceMap: true,
        extractComments: true,
        terserOptions: {
          module: true
        }
      }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    './js/app.js': ['./js/app.js'].concat(glob.sync('./vendor/**/*.js'))
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
            plugins: [
              '@babel/plugin-external-helpers',
              [
                '@babel/plugin-transform-runtime',
                {
                  useESModules: true
                }
              ],
              [
                '@babel/plugin-proposal-decorators',
                { decoratorsBeforeExport: false }
              ],
              ['@babel/plugin-proposal-class-properties', { loose: true }],
              [
                'template-html-minifier',
                {
                  modules: {
                    'lit-html': ['html'],
                    'lit-element': [
                      'html',
                      { name: 'css', encapsulation: 'style' }
                    ]
                  },
                  htmlMinifier: {
                    collapseWhitespace: true,
                    caseSensitive: true,
                    collapseBooleanAttributes: false,
                    removeComments: false
                  }
                }
              ]
            ]
          }
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: { implementation: require('sass') }
          }
        ]
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
    new ImageminPlugin({
      plugins: [imageminMozjpeg({ quality: 75 })]
    }),
    // new ZopfliPlugin({
    //   asset: '[path].gz[query]',
    //   algorithm: 'zopfli',
    //   test: /\.(js|css|html|svg)$/,
    //   threshold: 10240,
    //   minRatio: 0.8
    // }),
    new BrotliPlugin({
      asset: '[path].br[query]',
      test: /\.(js|css|html|svg)$/,
      threshold: 10240,
      minRatio: 0.8
    })
  ]
})
