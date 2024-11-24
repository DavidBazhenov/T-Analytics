import React from 'react'
import Image from 'next/image'
import ButtonDownload from './ButtonDownload'

const MainScreen = () => {
  return (
    <div className=' bg-[#1d1d1d] h-[666px] w-full mx-30px sm:mx-15vw overflow-hidden'>
      <div className="ml-[20px] sm:ml-[6vw] lg:ml-[20px] w-full h-full flex flex-row gap-[50px] lg:gap-[150px] items-center justify-center ">
        <div className="h-full bg-gradient-to-r from-[#1d1d1d] via-[#1d1d1dd0] to-[#1d1d1d1d] md:bg-gradient-none flex items-center justify-center relative z-10 p-4 lg:p-8 xl:p-12">
          <div className="flex flex-col justify-start gap-[24px] ">
            <h1 className='max-w-[300px] md:max-w-[450px] font-tinkoff font-bold text-white text-[44px] leading-10'>Финансовый помощник для iOS и Android</h1>
            <p className='max-w-[400px] font-tinkoff font-medium text-[#7E7E90] text-[24px] leading-6'>
              Анализируй свои финансы в доступном приложении на iOS и Android
            </p>
            <ButtonDownload />
          </div>
        </div>

        <div className="flex relative w-[200px] lg:w-[450px] left-[-220px] sm:left-[-300px] md:left-[-200px]  z-index-[-1] ">
          <div className="absolute w-[272px] h-[550px] top-[-275px] ">
            <Image
              src="/l-phone1.png"
              alt="logo"
              width={272}
              height={550}
            />
          </div>
          <div className="absolute w-[272px] h-[550px] top-[-240px] left-[170px]">
            <Image
              src="/l-phone2.png"
              alt="logo"
              width={272}
              height={544}
            />
          </div>
        </div>
      </div>
    </div>
  )
}

export default MainScreen