import { lambda } from './shared-webpack-lambda.mjs';
describe('sharedWebpackLambda', () => {
  it('should work', () => {
    expect(lambda({functions: []})).toEqual('shared-webpack-lambda');
  });
});
