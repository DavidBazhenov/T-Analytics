import React from 'react'
import FirstBlock from './FirstBlock'
import SecondBlock from './SecondBlock'
import ThirdBlock from './ThirdBlock'

const ArryayBlocks = () => {
    return (
        <div className='w-full max-w-[1920px] mx-[20px] sm:mx-[50px] md:mx-auto'>
            <FirstBlock />
            <SecondBlock />
            <ThirdBlock />
        </div>
    )
}

export default ArryayBlocks