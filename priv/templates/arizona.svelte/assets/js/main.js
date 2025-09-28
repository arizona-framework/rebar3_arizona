import Arizona from '@arizona-framework/client';
import ArizonaSvelte from './arizona-svelte.js';

// Initialize Arizona framework
globalThis.arizona = new Arizona({ logLevel: 'debug' });
arizona.connect({ wsPath: '/live' });

// Initialize ArizonaSvelte
const arizonaSvelte = new ArizonaSvelte();
arizonaSvelte.mountComponents();
