import { useState, useContext } from 'react'
import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
import LitJsSdk from 'lit-js-sdk'
import Cookies from 'js-cookie'
import { UUIDContext } from '../context'
import { useRouter } from 'next/router'


const accessControlConditions = [
  {
    contractAddress: '0xBF02bC0302995D5aa0B015c7e74E63909d7b0dC4',
    standardContractType: 'ERC721',
    chain: 'mumbai',
    method: 'balanceOf',
    parameters: [
      ':userAddress'
    ],
    returnValueTest: {
      comparator: '>',
      value: '0'
    }
  }
]

export default function Home() {
  const [connected, setConnected] = useState()
  const { id } = useContext(UUIDContext)

  async function connect() {
    const resourceId = {
      baseUrl: 'http://localhost:3000',
      path: '/protected',
      orgId: "",
      role: "",
      extraData: id
    }

    const client = new LitJsSdk.LitNodeClient({ alertWhenUnauthorized: false })
    await client.connect()
    const authSig = await LitJsSdk.checkAndSignAuthMessage({chain: 'mumbai'})

    await client.saveSigningCondition({ accessControlConditions, chain: 'ethereum', authSig, resourceId })
    try {
      const jwt = await client.getSignedToken({
        accessControlConditions, chain: 'ethereum', authSig, resourceId: resourceId
      })
      Cookies.set('lit-auth', jwt, { expires: 1 })

    } catch (err) {
      console.log('error: ', err)
    }
    setConnected(true)

  }


  return (
    <div className={styles.container}>
      {!connected && (
        <button className="w-full text-3xl font-bold mt-10 bg-pink-400 text-white rounded p-4 shadow-lg" onClick={connect}>
          Connect Wallet
        </button>
      )}
    </div>
  );
}
