import Link from 'next/link';
import Header from './components/layout/Header';

const NotFoundPage = () => {
  return (
    <>
      <Header />
      <div className="flex flex-col items-center justify-center min-h-screen">
        <h1 className="text-4xl font-bold text-gray-900">404</h1>
        <p className="mt-2 text-gray-600">ページが見つかりませんでした</p>
        <Link href="/" className="mt-4 text-blue-600 hover:underline">
          トップに戻る
        </Link>
      </div>
    </>
  );
};

export default NotFoundPage;
