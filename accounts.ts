const accounts = {
  sandbox: {
    alice: {
      privateKey: "edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq",
      publicKey: "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb",
    },
    bob: {
      privateKey: "edsk3RFfvaFaxbHx8BMtEW1rKQcPtDML3LXjNqMNLCzC3wLC1bWbAt",
      publicKey: "tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6",
    },
  },
  ghostnet: {
    alice: {
      privateKey: "edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq",
      publicKey: "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb",
    },
    bob: {
      privateKey: "edsk3RFfvaFaxbHx8BMtEW1rKQcPtDML3LXjNqMNLCzC3wLC1bWbAt",
      publicKey: "tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6",
    },
    admin: {
      publicKey: "tz1Z5M7s9QUVreNPCWjMx1jE1dj4eLFP4yrj",
      privateKey: process.env.ADMIN_PRIVATE_KEY,
    },
  },
  mainnet: {
    admin: {
      publicKey: "tz1Z5M7s9QUVreNPCWjMx1jE1dj4eLFP4yrj",
      privateKey: process.env.ADMIN_PRIVATE_KEY,
    },
  },
};

export default accounts;
