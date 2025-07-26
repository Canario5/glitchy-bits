import type { KnipConfig } from 'knip';

const config: KnipConfig = {
  ignoreBinaries: ['docker-compose', 'lefthook', 'commitlint'], //! lefthook + commitlint needed for knip --production
};

export default config;
