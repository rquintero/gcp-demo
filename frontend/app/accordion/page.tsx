'use client'

import { useState, useCallback } from 'react'
import { ChevronRightIcon, StarIcon, ShieldCheckIcon, RocketLaunchIcon } from '@heroicons/react/24/outline'

interface MosaicOption {
  id: string
  title: string
  description: string
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>
  color: string
  bgGradient: string
  features: string[]
  ctaText: string
  ariaLabel: string
}

const mosaicOptions: MosaicOption[] = [
  {
    id: 'premium',
    title: 'Premium Experience',
    description: 'Unlock advanced features and priority support for the ultimate user experience.',
    icon: StarIcon,
    color: 'text-amber-600',
    bgGradient: 'from-amber-50 to-orange-50',
    features: ['Priority Support', 'Advanced Analytics', 'Custom Integrations', 'Premium Templates'],
    ctaText: 'Go Premium',
    ariaLabel: 'Select Premium Experience option with priority support and advanced features'
  },
  {
    id: 'secure',
    title: 'Enterprise Security',
    description: 'Enterprise-grade security features to protect your data and ensure compliance.',
    icon: ShieldCheckIcon,
    color: 'text-emerald-600',
    bgGradient: 'from-emerald-50 to-teal-50',
    features: ['End-to-End Encryption', 'SSO Integration', 'Audit Logs', 'Compliance Reports'],
    ctaText: 'Secure Now',
    ariaLabel: 'Select Enterprise Security option with encryption and compliance features'
  },
  {
    id: 'performance',
    title: 'High Performance',
    description: 'Optimized performance tools and infrastructure for lightning-fast experiences.',
    icon: RocketLaunchIcon,
    color: 'text-blue-600',
    bgGradient: 'from-blue-50 to-indigo-50',
    features: ['CDN Acceleration', 'Auto Scaling', 'Performance Monitoring', 'Edge Computing'],
    ctaText: 'Boost Speed',
    ariaLabel: 'Select High Performance option with CDN and auto scaling features'
  }
]

export default function MosaicOptions() {
  const [selectedOption, setSelectedOption] = useState<string | null>(null)
  const [focusedOption, setFocusedOption] = useState<string | null>(null)
  const [announcementText, setAnnouncementText] = useState<string>('')

  const handleOptionSelect = useCallback((optionId: string) => {
    setSelectedOption(optionId)
    const selectedOptionData = mosaicOptions.find(opt => opt.id === optionId)
    const announcement = `Selected ${selectedOptionData?.title}. ${selectedOptionData?.description}`
    setAnnouncementText(announcement)
    
    // Clear announcement after screen reader has time to read it
    setTimeout(() => setAnnouncementText(''), 3000)
    
    console.log(`Selected option: ${optionId}`)
  }, [])

  const handleKeyDown = useCallback((e: React.KeyboardEvent, optionId: string) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault()
      handleOptionSelect(optionId)
    }
  }, [handleOptionSelect])

  const handleFocus = useCallback((optionId: string) => {
    setFocusedOption(optionId)
  }, [])

  const handleBlur = useCallback(() => {
    setFocusedOption(null)
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100">
      {/* Screen Reader Announcements */}
      <div 
        aria-live="polite" 
        aria-atomic="true" 
        className="sr-only"
        role="status"
      >
        {announcementText}
      </div>

      <div className="container mx-auto px-6 py-16">
        {/* Header Section */}
        <header className="text-center mb-16">
          <h1 className="text-5xl font-bold text-slate-900 mb-6">
            Choose Your Solution
          </h1>
          <p className="text-xl text-slate-600 max-w-3xl mx-auto leading-relaxed">
            Discover the perfect solution tailored to your needs. Each option is designed 
            to provide exceptional value and seamless integration with your workflow.
          </p>
        </header>

        {/* Mosaic Grid */}
        <main>
          <div 
            className="grid grid-cols-1 lg:grid-cols-3 gap-8 max-w-7xl mx-auto"
            role="group"
            aria-labelledby="mosaic-heading"
          >
            <h2 id="mosaic-heading" className="sr-only">
              Available Service Options
            </h2>
            
            {mosaicOptions.map((option, index) => {
              const IconComponent = option.icon
              const isFocused = focusedOption === option.id
              const isSelected = selectedOption === option.id
              
              return (
                <article
                  key={option.id}
                  className={`
                    relative group cursor-pointer transition-all duration-300 ease-out
                    transform hover:scale-105 hover:-translate-y-2
                    focus-within:scale-105 focus-within:-translate-y-2
                    ${isSelected ? 'ring-4 ring-blue-500 ring-opacity-50' : ''}
                    ${isFocused ? 'ring-2 ring-blue-400' : ''}
                  `}
                  role="button"
                  tabIndex={0}
                  aria-label={option.ariaLabel}
                  aria-pressed={isSelected}
                  aria-describedby={`${option.id}-description ${option.id}-features`}
                  onClick={() => handleOptionSelect(option.id)}
                  onKeyDown={(e) => handleKeyDown(e, option.id)}
                  onFocus={() => handleFocus(option.id)}
                  onBlur={handleBlur}
                >
                  {/* Card Container */}
                  <div className={`
                    relative overflow-hidden rounded-2xl shadow-lg
                    bg-gradient-to-br ${option.bgGradient}
                    border border-white/50 backdrop-blur-sm
                    transition-all duration-300
                    group-hover:shadow-2xl group-hover:border-white/80
                    group-focus-within:shadow-2xl group-focus-within:border-white/80
                    h-full min-h-[520px]
                  `}>
                    {/* Background Pattern */}
                    <div className="absolute inset-0 opacity-5" aria-hidden="true">
                      <div className="absolute inset-0 bg-gradient-to-br from-transparent via-white/20 to-transparent" />
                    </div>

                    {/* Content */}
                    <div className="relative p-8 h-full flex flex-col">
                      {/* Icon */}
                      <div className={`
                        w-16 h-16 rounded-xl ${option.color} mb-6
                        bg-white/80 backdrop-blur-sm shadow-sm
                        flex items-center justify-center
                        transition-all duration-300
                        group-hover:scale-110 group-hover:shadow-md
                        group-focus-within:scale-110 group-focus-within:shadow-md
                      `}>
                        <IconComponent 
                          className="w-8 h-8" 
                          aria-hidden="true" 
                          role="img"
                          aria-label={`${option.title} icon`}
                        />
                      </div>

                      {/* Title */}
                      <h3 className="text-2xl font-bold text-slate-900 mb-4">
                        {option.title}
                      </h3>

                      {/* Description */}
                      <p 
                        id={`${option.id}-description`}
                        className="text-slate-700 mb-6 leading-relaxed flex-grow"
                      >
                        {option.description}
                      </p>

                      {/* Features */}
                      <div className="mb-8">
                        <h4 className="text-sm font-semibold text-slate-800 mb-3 uppercase tracking-wide">
                          Key Features
                        </h4>
                        <ul 
                          id={`${option.id}-features`}
                          className="space-y-2"
                          role="list"
                        >
                          {option.features.map((feature, featureIndex) => (
                            <li 
                              key={featureIndex} 
                              className="flex items-center text-sm text-slate-700"
                              role="listitem"
                            >
                              <div 
                                className={`w-1.5 h-1.5 rounded-full ${option.color.replace('text-', 'bg-')} mr-3`}
                                aria-hidden="true"
                              />
                              {feature}
                            </li>
                          ))}
                        </ul>
                      </div>

                      {/* CTA Button */}
                      <button
                        className={`
                          w-full py-3 px-6 rounded-xl font-semibold
                          transition-all duration-200
                          flex items-center justify-center space-x-2
                          ${option.color} bg-white/90 hover:bg-white
                          border border-white/50 hover:border-white
                          shadow-sm hover:shadow-md
                          focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500
                          focus:bg-white
                        `}
                        onClick={(e) => {
                          e.stopPropagation()
                          handleOptionSelect(option.id)
                        }}
                        onKeyDown={(e) => {
                          if (e.key === 'Enter' || e.key === ' ') {
                            e.preventDefault()
                            e.stopPropagation()
                            handleOptionSelect(option.id)
                          }
                        }}
                        aria-label={`${option.ctaText} for ${option.title}`}
                        type="button"
                      >
                        <span>{option.ctaText}</span>
                        <ChevronRightIcon 
                          className={`w-4 h-4 transition-transform duration-200 group-hover:translate-x-1 group-focus-within:translate-x-1`}
                          aria-hidden="true"
                        />
                      </button>
                    </div>

                    {/* Hover/Focus Overlay */}
                    <div className={`
                      absolute inset-0 bg-gradient-to-br from-white/10 to-transparent
                      opacity-0 transition-opacity duration-300
                      group-hover:opacity-100 group-focus-within:opacity-100
                    `} aria-hidden="true" />
                  </div>

                  {/* Selection Indicator */}
                  {isSelected && (
                    <div 
                      className="absolute -top-2 -right-2 w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center shadow-lg"
                      aria-hidden="true"
                    >
                      <div className="w-2 h-2 bg-white rounded-full" />
                    </div>
                  )}
                </article>
              )
            })}
          </div>
        </main>

        {/* Selected Option Feedback */}
        {selectedOption && (
          <aside className="mt-12 text-center" role="complementary">
            <div className="inline-flex items-center px-6 py-3 rounded-full bg-blue-100 text-blue-800 font-medium">
              <StarIcon className="w-5 h-5 mr-2" aria-hidden="true" />
              <span>
                You selected: {mosaicOptions.find(opt => opt.id === selectedOption)?.title}
              </span>
            </div>
          </aside>
        )}
      </div>
    </div>
  )
}