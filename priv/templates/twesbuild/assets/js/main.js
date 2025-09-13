import Arizona from '@arizona-framework/client';
const arizona = new Arizona({ logLevel: 'debug' });
arizona.connect({ wsPath: '/live' });
