// Script that uses context
const feature = context.feature.name;
const phase = context.phases.current;

return {
  status: 'complete',
  message: `Processing ${feature} in ${phase}`
};
