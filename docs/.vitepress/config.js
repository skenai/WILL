export default {
  title: 'WILL Documentation',
  description: 'Web3 Intelligence & Learning Layer',
  
  themeConfig: {
    logo: '/logo.png',
    nav: [
      { text: 'Guide', link: '/guide/' },
      { text: 'API', link: '/api/' },
      { text: 'Examples', link: '/examples/' },
      { text: 'GitHub', link: 'https://github.com/shibakenfinance/WILL' }
    ],
    
    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'What is WILL?', link: '/introduction/what-is-will' },
          { text: 'Getting Started', link: '/introduction/getting-started' }
        ]
      },
      {
        text: 'Architecture',
        items: [
          { text: 'Overview', link: '/architecture/' },
          { text: 'Components', link: '/architecture/components' }
        ]
      },
      {
        text: 'API Reference',
        items: [
          { text: 'Overview', link: '/api/' },
          { text: 'Authentication', link: '/api/auth' },
          { text: 'Endpoints', link: '/api/endpoints' }
        ]
      }
    ],

    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2025 SKENAI DAO'
    }
  }
}
