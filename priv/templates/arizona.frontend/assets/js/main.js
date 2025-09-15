import Arizona from '@arizona-framework/client';
globalThis.arizona = new Arizona({ logLevel: 'debug' });
arizona.connect({ wsPath: '/live' });
