/* pages/_app.js */
import '../styles/globals.css'
import Link from 'next/link'
import { UUIDContext } from '../context'
import { useRouter } from 'next/router'
import { v4 as uuid } from 'uuid';
const id = uuid()

function MyApp({ Component, pageProps }) {
  const router = useRouter();
  function navigate() {
    router.push(`/protected?id=${id}`)
  }

  return (
    <div >
      <nav className="border-b p-6 bg-black">
        <p className="text-6xl font-bold text-white " >AstroFT</p> 
        <p className="font-bold text-color-white text-white ">A Community of astronomy enthusiasts</p>
        <div className="fflex mt-4 font-bold font-sans ml-8 text-center">
          {/* <Link href="/explore">
            <a className="mr-4 text-white text-2xl">
              Home
            </a>
          </Link> */}
          {/* <Link href="/upload-video">
            <a className="mr-6 text-white text-2xl">
              Upload-Video
            </a>
          </Link> */}
          <Link href="/protected">
            <a onClick={navigate} style={{ cursor: 'pointer' }} className="mr-6 text-white text-2xl">
              Stream-Live
            </a>
          </Link>
          
        </div>

      </nav>

      <UUIDContext.Provider value={{
        id
      }}>
        <Component {...pageProps} />
      </UUIDContext.Provider>
    </div>
  )
}

export default MyApp