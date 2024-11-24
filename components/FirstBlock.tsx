import React from 'react'
import Image from 'next/image'

const FirstBlock = () => {
    return (
        <div className='px-[50px] lg-1275:px-[16vw] w-full flex flex-row flex-wrap items-center justify-center lg-1275:justify-between '>
            <div className="w-[248px] h-[498px] relative lg-1275:top-[200px] lg-1275:left-[50px]">
                <Image
                    src="/block1.png"
                    alt="logo"
                    width={248}
                    height={498}
                />
            </div>
            <div className="flex flex-col overflow-hidden pt-[20px] lg-1275:pt-0">
                <p
                    style={{
                        background: 'linear-gradient(180deg, #FDDD34 0%, #fee77282 28%, #feec9471 46%, #feed964b 63%, #ffffff00 93%)',
                        WebkitBackgroundClip: 'text', // Это нужно для того, чтобы градиент применился к тексту
                    }}
                    className="hidden lg-1275:block font-holtwood font-medium text-transparent text-[512px] leading-[400px] relative top-[100px] left-[160px]"
                >
                    1
                </p>

                <h3 className='max-w-[530px] font-tinkoff font-medium text-white text-[34px] leading-10'>Контролируйте свои финансы</h3>
                <p className='max-w-[530px] font-tinkoff font-regular text-[#7E7E90] text-[24px] leading-6'>Синхронизируйте банковские счета, чтобы все транзакции автоматически загружались в T Аналитика.
                    Добавьте банковские карты и электронные кошельки для комплексного управления денежными потоками.
                    Вносите свои наличные расходы вручную.
                </p>
            </div>
        </div>
    )
}

export default FirstBlock