import React from 'react'
import Image from 'next/image'

const ButtonDownload = () => {
    return (
        <div className='w-[150px] py-1 px-2 flex flex-row items-center justify-center gap-1 bg-[#FDDD34] rounded-[9px] h-[32px] cursor-pointer hover:bg-[#fddb34c3]'>
            <p className='font-tinkoff font-medium text-[#1d1d1d] text-base leading-3'>
                Скачать
            </p>
            <div className="w-[12px] h-[12px]">
                <Image
                    src={"/download.png"}
                    alt="logo"
                    width={12}
                    height={12}
                />
            </div>
        </div>
    )
}

export default ButtonDownload