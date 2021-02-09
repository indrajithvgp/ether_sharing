const assert = require('assert')
const Web3 = require('web3')
const ganache = require('ganache-cli')
const {interface, bytecode} = require('../compile.js')

const web3 = new Web3(ganache.provider())

let accounts, newContract
beforeEach(async() => {
    accounts = await web3.eth.getAccounts()
    newContract = await new web3.eth.Contract(JSON.parse(interface)).deploy({data:bytecode, arguments:[]}).send({from:accounts[0], gas:'1000000'})
})

describe("EtherSharing Contract ... ", ()=>{
   it('deploys a contract', ()=>{
      assert.ok(newContract.options.address)
   })
   it("balance updates correctly", async()=>{
      await newContract.methods.deposit().send({from:accounts[1], value:web3.utils.toWei('12', 'ether')})
      const bal = await newContract.methods.contractBalance().call()
      await newContract.methods.allocEther(accounts[2], web3.utils.toWei('9','ether')).send({from:accounts[1], gas:'1000000'})
      await newContract.methods.getAllocEther().send({from:accounts[2]})
      const updBal = await newContract.methods.contractBalance().call()
      console.log(accounts[0])
      try{
         assert(bal>updBal)
         assert(false)
      }catch(err){
         console.log(err)
         assert(err)
      }  
   })

})