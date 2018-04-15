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
            <li key={product.id}>{product.title}: {product.price}</li>,
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
    }
  }
`)(Products);
