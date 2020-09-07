const MarketPlace = artifacts.require('./MarketPlace.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('MarketPlace', (accounts) => {
  let contract

  before(async () => {
    contract = await MarketPlace.deployed()
  })

  describe('deployment', async () => {
    it('deploys successfully', async () => {
      const address = contract.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })

    it('has a name', async () => {
      const name = await contract.name()
      assert.equal(name, 'Asset')
    })

    it('has a symbol', async () => {
      const symbol = await contract.symbol()
      assert.equal(symbol, 'AST')
    })

  })

  describe('minting', async () => {

    it('creates a new token', async () => {
      const result = await contract.mint('my asset2',100,'tdtd2tdtdt')

      console.log(result.logs[0].args)
      const totalSupply = await contract.totalSupply()
      // SUCCESS
      assert.equal(totalSupply, 1)
      const event = result.logs[0].args
      assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
      assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
      assert.equal(event.to, accounts[0], 'to is correct')

      // FAILURE: cannot mint same color twice
      await contract.mint('my asset',100,'tdtdtdtdt').should.be.rejected;
    })
  })

//   describe('indexing', async () => {
//     it('lists colors', async () => {
//       // Mint 3 more tokens
//       await contract.mint('#5386E4')
//       await contract.mint('#FFFFFF')
//       await contract.mint('#000000')
//       const totalSupply = await contract.totalSupply()

//       let color
//       let result = []

//       for (var i = 1; i <= totalSupply; i++) {
//         color = await contract.colors(i - 1)
//         result.push(color)
//       }

//       let expected = ['#EC058E', '#5386E4', '#FFFFFF', '#000000']
//       assert.equal(result.join(','), expected.join(','))
//     })
//   })

})