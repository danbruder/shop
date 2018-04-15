import React from 'react';
import {graphql} from 'react-apollo';
import gql from 'graphql-tag';

function Products({data: {allProducts, refetch}}) {
  return (
    <div>
      <button onClick={() => refetch()}>Refresh</button>
      <ul>
        {allProducts &&
          allProducts.map(product =>
            <li key={product.id}>
              {product.title}: {product.price}.{' '}
              {product.categories.map((c, i) => <div key={i}>{c.name}</div>)}
            </li>,
          )}
      </ul>
    </div>
  );
}

export default graphql(gql`
  query ProductsQuery {
    allProducts {
      id
      title
      price
      categories {
        name
      }
    }
  }
`)(Products);
