import { useEffect, useRef, useState } from 'react';

const FadeIn = ({
  children,
  delay = 0,
  direction = 'up',
  className = '',
  fullWidth = false,
  duration = 700,
  threshold = 0.1,
  rootMargin = '0px 0px -50px 0px',
  ...props
}) => {
  const [isVisible, setIsVisible] = useState(false);
  const domRef = useRef();

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setIsVisible(true);
          }
        });
      },
      {
        threshold,
        rootMargin,
      }
    );

    const { current } = domRef;
    if (current) {
      observer.observe(current);
    }

    return () => {
      if (current) {
        observer.unobserve(current);
      }
    };
  }, []);

  const getDirectionClasses = () => {
    switch (direction) {
      case 'up':
        return 'translate-y-8';
      case 'down':
        return '-translate-y-8';
      case 'left':
        return 'translate-x-8';
      case 'right':
        return '-translate-x-8';
      case 'none':
        return '';
      default:
        return 'translate-y-8';
    }
  };

  return (
    <div
      ref={domRef}
      className={`transition-all ease-out transform ${
        isVisible
          ? 'opacity-100 translate-y-0 translate-x-0 blur-0'
          : `opacity-0 blur-[2px] ${getDirectionClasses()}`
      } ${className} ${fullWidth ? 'w-full' : ''}`}
      style={{
        ...props.style,
        transitionDuration: `${duration}ms`,
        transitionDelay: `${delay}ms`,
      }}
      {...props}
    >
      {children}
    </div>
  );
};

export default FadeIn;
