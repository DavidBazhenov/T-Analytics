import React from 'react'
import Image from 'next/image'

const Header = () => {
  return (
    <div className='h-[64px] w-full bg-[#2E2F34] flex items-center justify-center'>
      <div className="container mx-[30px] ">
        <div className="flex items-center justify-center sm:pl-[5vw] lg:pl-[10vw] ">
          <Image
            src="/logo.png"
            alt="logo"
            width={50}
            height={50}
          />
          <h2 className='font-tinkoff font-medium text-white text-4xl leading-8 pb-2'>Аналитика</h2>
          <div className="flex grow" />
        </div>
      </div>
    </div>
  )
}

export default Header