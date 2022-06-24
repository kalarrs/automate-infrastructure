module.exports = async (config, options) => {
  const {lambda} = await import('@kalarrs-automate-infrastructure/shared-webpack-lambda/index.mjs');
  const getConfig = lambda({dirName: __dirname});
  return await getConfig(config, options);
};
