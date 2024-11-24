import React from 'react'
import Image from 'next/image'

const StartBanner = () => {
    return (
        <div className='w-full mx-30px sm:mx-15vw  pt-[100px] overflow-hidden px-[30px] pb-[100px]'>
            <div className="flex flex-col lg:flex-row items-center justify-center gap-[100px]">
                <div className="flex flex-col gap-[30px] min-w-[300px] md:max-w-[560px]  ">
                    <div className="flex flex-col">
                        <h2 className='font-tinkoff font-medium text-white text-[34px] leading-10'>Управляйте финансами с легкостью</h2>
                        <p className='max-w-[560px] font-tinkoff font-regular text-[#7E7E90] text-[24px] leading-6'>Сделайте управление деньгами простым и удобным. Синхронизируйте банковские счета, добавьте карты и кошельки для автоматического учета всех транзакций.</p>
                    </div>
                    <div className="flex flex-row gap-[15px]">
                        <div className="flex flex-col gap-[15px]">
                            <div className="w-[30px] h-[30px]">
                                <Image
                                    src="/diagramm-icon.png"
                                    width={30}
                                    height={30}
                                    alt="diagramm"
                                />
                            </div>
                            <h3 className='font-tinkoff font-regular text-white text-[24px] leading-6'>
                                Иметь полный контроль
                            </h3>
                            <p className='max-w-[260px] font-tinkoff font-regular text-[#7E7E90] text-[24px] leading-6'>над всеми своими расходами наличными, банковскими счетами и электронными кошельками.</p>
                        </div>
                        <div className="flex flex-col gap-[15px]">
                            <div className="w-[30px] h-[30px]">
                                <Image
                                    src="/clock-icon.png"
                                    width={30}
                                    height={30}
                                    alt="diagramm"
                                />
                            </div>
                            <h3 className='font-tinkoff font-regular text-white text-[24px] leading-6'>
                                Иметь полный контроль
                            </h3>
                            <p className='max-w-[260px] font-tinkoff font-regular text-[#7E7E90] text-[24px] leading-6'>над всеми своими расходами наличными, банковскими счетами и электронными кошельками.</p>
                        </div>
                    </div>
                </div>
                <div className="lg:relative lg:w-[450px] lg:left-0 z-[-1] ">
                    <div className="pr-4 lg:pr-0 lg:absolute w-[500px] h-[400px] lg:top-[-170px] lg:left-[-40px] ">
                        <Image
                            src="/stat.png"
                            alt="stat"
                            width={500}
                            height={400}
                        />
                    </div>
                    <div className="flex items-center justify-center lg:absolute lg:w-[280px] h-[400px] lg:top-[-200px] lg:left-[250px] ">
                        <Image
                            src="/othcet.png"
                            alt="stat"
                            width={280}
                            height={400}
                        />
                    </div>
                </div>
            </div>
        </div>
    )
}

export default StartBanner