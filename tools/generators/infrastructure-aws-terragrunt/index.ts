import {Tree, formatFiles, installPackagesTask, generateFiles, joinPathFragments} from '@nrwl/devkit';
import * as prompts from 'prompts';
import {loadSharedConfigFiles} from '@aws-sdk/shared-ini-file-loader';
import {argv} from 'yargs';

export interface Schema {
  name: string;
}

const arrayToChoices = arr => arr.map(value => ({value}));

export default async function (tree: Tree, {name}: Schema) {
  prompts.override(argv);
  if (/\/infrastructure\/aws\//.test(process.env.INIT_CWD)) {
    const {useInitCwd} = await prompts({
      type: 'confirm',
      name: 'useInitCwd',
      message: 'Use current path to populate values?',
      initial: true,
    });
    if (useInitCwd) {
      const {groups} = /aws\/(?<profile>[^\/]+)\/?((stages\/(?<stage>[^\/]+)\/?|environments\/(?<environment>[^\/]+)\/?)(?<region>[^\/]+)?)?/.exec(process.env.INIT_CWD);
      prompts.override(groups);
    }
  }
  // TODO : read values from schema.dynamic instead of hard coding into this file?
  const {configFile} = await loadSharedConfigFiles();
  const profiles = Object.keys(configFile);
  const {profile} = await prompts({
    type: 'select',
    name: 'profile',
    message: 'What is the AWS profile you want to use?',
    choices: arrayToChoices(profiles),
  });
  const activeProfile = configFile[profile];

  const regions = ['global', 'us-east-1', 'us-east-2', 'us-west-1', 'us-west-2'];
  const environment = ''; // TODO : do we want to support environments?
  const {region, stage} = await prompts([
    {
      type: 'select',
      name: 'region',
      message: 'Which region?',
      choices: arrayToChoices(regions),
      initial: regions.indexOf(activeProfile?.region) >= 0 ? regions.indexOf(activeProfile?.region) : null
    },
    {
      type: 'select',
      name: 'stage',
      message: 'Which stage?',
      choices: [
        {value: 'dev', title: 'Development'},
        {value: 'qa', title: 'Quality Assurance'},
        {value: 'staging', title: 'Staging'},
        {value: 'prod', title: 'Production'},
      ],
    },
  ]);

  const moduleNames = tree.children('/terraform/aws');
  const hasDependencies = false; // TODO: show a list of dependencies by region and allow multi select
  const {module} = await prompts({
    type: 'select',
    name: 'module',
    message: 'Name of terraform module?',
    choices: arrayToChoices(moduleNames),
    initial: moduleNames.findIndex(n => name.includes(n)),
  });
  const mainText = tree.read(`/terraform/aws/${module}/main.tf`).toString('utf8');
  const hasNestedModules = /source\s+=.*?"..\//mi.test(mainText);

  const isEnv = environment?.length > 1;
  const stageOrEnvironmentName = isEnv ? `${stage}-${environment}` : stage;
  const type = isEnv ? 'environments' : 'stages';

  const tmpl = '';

  generateFiles(
    tree,
    joinPathFragments(__dirname, `./files`),
    joinPathFragments(`./infrastructure/aws/${profile}/${type}/${stageOrEnvironmentName}/${region}/${name}`),
    {module, hasDependencies, hasNestedModules, tmpl}
  );

  await formatFiles(tree);
  return () => {
    installPackagesTask(tree);
  };
}
