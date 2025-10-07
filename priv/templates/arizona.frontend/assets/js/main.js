import { Arizona, ArizonaConsoleLogger, LOG_LEVELS } from '@arizona-framework/client';
const logger = new ArizonaConsoleLogger({ logLevel: LOG_LEVELS.debug });
globalThis.arizona = new Arizona({ logger });
arizona.connect('/live');
