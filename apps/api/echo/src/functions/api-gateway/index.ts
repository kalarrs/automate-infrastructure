import {captureAWSv3Client} from 'aws-xray-sdk-core';
import {APIGatewayProxyHandlerV2} from 'aws-lambda';
import {GetParameterCommand, SSMClient} from '@aws-sdk/client-ssm';

const {AWS_REGION: region, APP_CONFIG_PATH: appConfigPath} = process.env;
const ssmClient = captureAWSv3Client(new SSMClient({region}));

export const handler: APIGatewayProxyHandlerV2 = async (event) => {
  const {
    Parameter: {Value: value},
  } = await ssmClient.send(
    new GetParameterCommand({
      Name: appConfigPath,
      WithDecryption: true,
    })
  );

  if (value) {
    console.log('Able to get app config!');
  }

  const {queryStringParameters} = event;

  return {
    isBase64Encoded: false,
    statusCode: 200,
    body: JSON.stringify({queryStringParameters}),
    headers: {'content-type': 'application/json'},
  };
};
