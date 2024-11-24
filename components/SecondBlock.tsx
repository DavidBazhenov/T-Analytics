import React from 'react'
import Image from 'next/image'

const FirstBlock = () => {
    return (
        <div className='px-[50px] lg-1275:px-[16vw] w-full flex flex-row flex-wrap justify-center lg-1275:justify-between relative pt-[50px] lg-1275:pt-0 lg-1275:top-[-50px]'>
            <div className="flex flex-col ">
                <p
                    style={{
                        background: 'linear-gradient(180deg, #FDDD34 0%, #fee77282 28%, #feec9471 46%, #feed964b 63%, #ffffff00 93%)',
                        WebkitBackgroundClip: 'text', // Это нужно для того, чтобы градиент применился к тексту
                    }}
                    className="hidden lg-1275:block  font-holtwood font-medium text-transparent text-[512px] leading-[400px] relative top-[100px] left-[-10px]"
                >
                    2
                </p>

                <h3 className='max-w-[530px] font-tinkoff font-medium text-white text-[34px] leading-10'>Поймите свои финансовые привычки</h3>
                <p className='max-w-[530px] font-tinkoff font-regular text-[#7E7E90] text-[24px] leading-6'>Исследуйте свои финансы с помощью удобных и наглядных графиков, без необходимости использовать сложные таблицы.
                    Узнайте, на что уходят ваши деньги и откуда они поступают ежемесячно.
                    Проверьте, превышают ли ваши доходы расходы в удобном интерфейсе одним кликом.
                    Вносите свои наличные расходы вручную.
                </p>
            </div>
            <div className="w-[248px] h-[498px] relative lg-1275:top-[220px] lg-1275:left-[-100px]">
                <Image
                    src="/l-phone2.png"
                    alt="logo"
                    width={248}
                    height={498}
                />
            </div>

        </div>
    )
}

export default FirstBlock