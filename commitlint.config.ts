import type { UserConfig } from '@commitlint/types';
import { RuleConfigSeverity } from '@commitlint/types';

/*?
help:
https://github.com/conventional-changelog/commitlint/#what-is-commitlint

config explained:
https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional
*/

const Configuration: UserConfig = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'body-leading-blank': [RuleConfigSeverity.Error, 'always'], // changed from warning to error
  },
};

export default Configuration;
