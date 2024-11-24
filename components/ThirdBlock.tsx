import React from 'react'
import Image from 'next/image'

const ThirdBlock = () => {
    return (
        <div className='px-[50px] lg-1275:px-[16vw]   w-full flex flex-row justify-between relative pt-[50px] lg-1275:pt-0 lg-1275:top-[-150px]'>
            <div className="w-[248px] h-[498px] relative top-[220px] left-[-100px]">

            </div>
            <div className="flex flex-col ">
                <p
                    style={{
                        background: 'linear-gradient(180deg, #FDDD34 0%, #fee77282 28%, #feec9471 46%, #feed964b 63%, #ffffff00 93%)',
                        WebkitBackgroundClip: 'text', // Это нужно для того, чтобы градиент применился к тексту
                    }}
                    className="hidden lg-1275:block  font-holtwood font-medium text-transparent text-[512px] leading-[400px] relative top-[100px] left-[160px]"
                >
                    3
                </p>

                <h3 className='max-w-[530px] font-tinkoff font-medium text-white text-[34px] leading-10'>Планируйте свои финансы эффективно</h3>
                <p className='max-w-[530px] font-tinkoff font-regular text-[#7E7E90] text-[24px] leading-6'>
                    Прогнозируйте свои расходы на основе доходов и предыдущих трат.
                    Анализируйте данные с помощью интуитивно понятных графиков
                    Создавайте и управляйте своим бюджетом легко.
                </p>
            </div>


        </div>
    )
}

export default ThirdBlock