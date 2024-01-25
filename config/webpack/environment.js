const { environment } = require('@rails/webpacker');

// Find the Babel loader in the existing loaders
const babelLoader = environment.loaders.get('babel');

// Push the required presets and plugins to the Babel loader options
babelLoader.use[0].options.presets.push('@babel/preset-env');
babelLoader.use[0].options.plugins.push('@babel/plugin-proposal-private-methods');

module.exports = environment;
